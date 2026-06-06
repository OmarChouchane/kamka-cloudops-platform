const { User } = require('../../../database/models');

const listUsers = async (req, res) => {
  try {
    const users = await User.findAll({ order: [['createdAt', 'DESC']] });
    return res.status(200).json(users);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

const createUser = async (req, res) => {
  try {
    const { firstName, lastName, email } = req.body;
    const user = await User.create({ firstName, lastName, email });
    return res.status(201).json(user);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

const updateUser = async (req, res) => {
  try {
    const user = await User.findByPk(req.params.id);
    if (!user) return res.status(404).json({ error: 'User not found' });
    const { firstName, lastName, email } = req.body;
    await user.update({ firstName, lastName, email });
    return res.status(200).json(user);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

const deleteUser = async (req, res) => {
  try {
    const user = await User.findByPk(req.params.id);
    if (!user) return res.status(404).json({ error: 'User not found' });
    await user.destroy();
    return res.status(204).send();
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

module.exports = { listUsers, createUser, updateUser, deleteUser };
