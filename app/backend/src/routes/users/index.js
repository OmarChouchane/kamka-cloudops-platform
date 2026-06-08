const { Router } = require('express')
const {
  listUsers,
  createUser,
  updateUser,
  deleteUser,
} = require('../../controller/users/index')

const usersRoute = Router()
usersRoute.get('/users', listUsers)
usersRoute.post('/users', createUser)
usersRoute.put('/users/:id', updateUser)
usersRoute.delete('/users/:id', deleteUser)

module.exports = { usersRoute }
