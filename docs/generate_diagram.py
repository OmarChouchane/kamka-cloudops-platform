from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import EC2
from diagrams.aws.network import VPC, InternetGateway, ElasticLoadBalancing
from diagrams.aws.security import IAM
from diagrams.aws.management import SSM
from diagrams.aws.storage import S3
from diagrams.aws.database import DynamodbTable
from diagrams.onprem.container import Docker
from diagrams.onprem.monitoring import Prometheus, Grafana
from diagrams.onprem.network import Caddy
from diagrams.onprem.database import PostgreSQL
from diagrams.onprem.ci import GithubActions
from diagrams.onprem.vcs import Github
from diagrams.saas.chat import Slack
from diagrams.generic.compute import Rack

graph_attr = {
    "fontsize": "13",
    "bgcolor": "white",
    "pad": "0.5",
    "splines": "ortho",
    "nodesep": "0.6",
    "ranksep": "0.9",
}

with Diagram(
    "Kamka CloudOps Platform — AWS Architecture",
    filename="docs/architecture",
    outformat="png",
    graph_attr=graph_attr,
    show=False,
    direction="LR",
):

    github = Github("GitHub\nRepository")
    ghcr   = Rack("GHCR\nRegistry")
    slack  = Slack("Slack\n#kamka-alerts")
    ci     = GithubActions("GitHub Actions\n4-job Pipeline")

    with Cluster("AWS — eu-west-1"):

        with Cluster("IAM"):
            iam_ec2 = IAM("EC2 Role\n(SSM read)")
            iam_gha = IAM("OIDC Role\n(GitHub Actions)")

        ssm = SSM("SSM Parameter Store\nDB · Slack · Grafana")
        s3  = S3("S3\nTF state · backups")
        ddb = DynamodbTable("DynamoDB\nTF locks")

        with Cluster("VPC  10.0.0.0/16"):
            igw = InternetGateway("Internet\nGateway")

            with Cluster("Public Subnet  10.0.1.0/24"):
                ec2 = EC2("EC2  t3.micro\nElastic IP")

                with Cluster("Docker Compose"):
                    caddy    = Caddy("Caddy\n:80 / :443")
                    frontend = Docker("Frontend\nNext.js")
                    api      = Docker("Backend\nNode.js")
                    db       = PostgreSQL("PostgreSQL 15")

                with Cluster("Observability"):
                    prom  = Prometheus("Prometheus")
                    graf  = Grafana("Grafana")
                    alert = Docker("Alertmanager")
                    node  = Docker("Node Exporter")
                    cadv  = Docker("cAdvisor")

    # CI/CD flow
    github >> ci
    ci >> Edge(label="OIDC", style="dashed") >> iam_gha
    ci >> Edge(label="push images") >> ghcr
    ci >> Edge(label="SSH deploy") >> ec2

    # Traffic
    igw >> caddy
    caddy >> frontend
    caddy >> api
    api >> db

    # Observability
    prom >> graf
    prom >> alert
    alert >> Edge(label="webhook") >> slack
    node >> prom
    cadv >> prom
    api >> Edge(label="/metrics", style="dashed") >> prom

    # AWS services
    ec2 >> Edge(label="fetch secrets") >> ssm
    ssm >> iam_ec2
    s3 >> ddb

    # Images pulled
    ghcr >> Edge(label="pull", style="dashed") >> ec2
