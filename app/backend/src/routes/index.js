const { Router } = require('express')
const { helloRoute } = require('./hello/index')
const { usersRoute } = require('./users/index')

const routes = Router()

routes.get('/healthz', (req, res) => {
  res.status(200).json({ status: 'ok', service: 'api' })
})

routes.use(helloRoute)
routes.use(usersRoute)
module.exports = { routes }
