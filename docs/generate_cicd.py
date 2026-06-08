import urllib.request
import os
from diagrams import Diagram, Cluster, Edge
from diagrams.custom import Custom
from diagrams.onprem.vcs import Github
from diagrams.onprem.ci import GithubActions
from diagrams.onprem.security import Trivy
from diagrams.aws.compute import EC2
from diagrams.aws.security import IAM
from diagrams.aws.management import SSM
from diagrams.saas.chat import Slack
from diagrams.generic.compute import Rack

# ── Download custom icons ──────────────────────────────────────────────────────
ICONS = {
    "sonarcloud": ("https://avatars.githubusercontent.com/u/37965312", "docs/icons/sonarcloud.png"),
    "eslint":     ("https://eslint.org/icon-512.png",                  "docs/icons/eslint.png"),
    "prettier":   ("https://prettier.io/icon.png",                     "docs/icons/prettier.png"),
    "mocha":      ("https://mochajs.org/static/apple-touch-icon.png",  "docs/icons/mocha.png"),
    "docker":     ("https://www.docker.com/wp-content/uploads/2022/03/Moby-logo.png", "docs/icons/docker.png"),
}

os.makedirs("docs/icons", exist_ok=True)
for name, (url, path) in ICONS.items():
    if not os.path.exists(path):
        print(f"Downloading {name} icon...")
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
            with urllib.request.urlopen(req, timeout=10) as r, open(path, "wb") as f:
                f.write(r.read())
        except Exception as e:
            print(f"  Failed: {e} — using fallback")

# ── Diagram ────────────────────────────────────────────────────────────────────
graph_attr = {
    "fontsize": "12",
    "bgcolor": "white",
    "pad": "0.7",
    "splines": "ortho",
    "nodesep": "0.7",
    "ranksep": "1.1",
    "fontname": "Helvetica",
}

def icon(name, label):
    path = ICONS[name][1]
    if os.path.exists(path):
        return Custom(label, path)
    return GithubActions(label)

with Diagram(
    "Kamka CI/CD Pipeline",
    filename="docs/cicd_pipeline",
    outformat="png",
    graph_attr=graph_attr,
    show=False,
    direction="LR",
):
    push = Github("git push\nmaster")
    slack = Slack("Slack\n#kamka-alerts")

    with Cluster("Job 1 — Lint & Test"):
        eslint   = icon("eslint",   "ESLint")
        prettier = icon("prettier", "Prettier")
        mocha    = icon("mocha",    "Mocha Tests")
        eslint >> prettier >> mocha

    with Cluster("Job 2 — Security Scan"):
        sonar    = icon("sonarcloud", "SonarCloud\nSAST")
        trivy_fs = Trivy("Trivy FS\nbackend + frontend")
        sonar >> trivy_fs

    with Cluster("Job 3 — Build & Push\n(needs Job 1 + 2)"):
        build     = icon("docker", "Docker Build\nbackend + frontend")
        trivy_img = Trivy("Trivy Image\nScan")
        ghcr      = Rack("Push to GHCR")
        build >> trivy_img >> ghcr

    with Cluster("Job 4 — Deploy\n(needs Job 3)"):
        oidc    = IAM("OIDC\nAWS Auth")
        ssm     = SSM("Fetch Secrets\nfrom SSM")
        ec2     = EC2("EC2 Rolling\nUpdate")
        migrate = GithubActions("DB Migrate\n+ Health Check")
        oidc >> ec2
        ssm  >> ec2
        ec2  >> migrate

    # Main pipeline flow
    push >> Edge(label="triggers") >> eslint
    push >> Edge(label="triggers") >> sonar

    mocha    >> Edge(label="✓ pass") >> build
    trivy_fs >> Edge(label="✓ pass") >> build

    ghcr >> Edge(label="on push") >> oidc

    # Slack notifications (dashed)
    trivy_fs  >> Edge(label="report", style="dashed", color="darkorange") >> slack
    trivy_img >> Edge(label="report", style="dashed", color="darkorange") >> slack
    migrate   >> Edge(label="notify", style="dashed", color="green")      >> slack
