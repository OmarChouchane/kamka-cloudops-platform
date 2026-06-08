import { useState, useEffect } from 'react'
import { Inter } from 'next/font/google'

const inter = Inter({ subsets: ['latin'] })
const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000'

const EMPTY_FORM = { firstName: '', lastName: '', email: '' }

export default function Home() {
  const [users, setUsers] = useState([])
  const [loading, setLoading] = useState(true)
  const [form, setForm] = useState(EMPTY_FORM)
  const [editingId, setEditingId] = useState(null)
  const [editForm, setEditForm] = useState(EMPTY_FORM)
  const [notice, setNotice] = useState(null)

  const flash = (msg, type = 'success') => {
    setNotice({ msg, type })
    setTimeout(() => setNotice(null), 3000)
  }

  const fetchUsers = async () => {
    try {
      const res = await fetch(`${API_URL}/users`)
      setUsers(await res.json())
    } catch {
      // backend warming up
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    fetchUsers()
  }, [])

  const handleCreate = async (e) => {
    e.preventDefault()
    try {
      const res = await fetch(`${API_URL}/users`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(form),
      })
      if (!res.ok) throw new Error()
      setForm(EMPTY_FORM)
      flash('User created.')
      fetchUsers()
    } catch {
      flash('Failed to create user.', 'error')
    }
  }

  const startEdit = (user) => {
    setEditingId(user.id)
    setEditForm({
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
    })
  }

  const handleUpdate = async (id) => {
    try {
      const res = await fetch(`${API_URL}/users/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(editForm),
      })
      if (!res.ok) throw new Error()
      setEditingId(null)
      flash('User updated.')
      fetchUsers()
    } catch {
      flash('Failed to update user.', 'error')
    }
  }

  const handleDelete = async (id) => {
    try {
      const res = await fetch(`${API_URL}/users/${id}`, { method: 'DELETE' })
      if (!res.ok) throw new Error()
      flash('User deleted.')
      fetchUsers()
    } catch {
      flash('Failed to delete user.', 'error')
    }
  }

  return (
    <main
      className={`min-h-screen bg-gray-950 text-white p-8 ${inter.className}`}
    >
      <div className="max-w-2xl mx-auto">
        <div className="mb-10">
          <h1 className="text-3xl font-bold tracking-tight">KAMKA CloudOps</h1>
          <p className="text-gray-400 text-sm mt-1">
            User directory · Frontend → API → PostgreSQL
          </p>
        </div>

        {notice && (
          <div
            className={`mb-4 px-4 py-2 rounded-lg text-sm ${
              notice.type === 'error'
                ? 'bg-red-900/40 text-red-300'
                : 'bg-green-900/40 text-green-300'
            }`}
          >
            {notice.msg}
          </div>
        )}

        {/* Create form */}
        <div className="bg-gray-900 border border-gray-800 rounded-xl p-6 mb-6">
          <h2 className="text-base font-semibold mb-4">New User</h2>
          <form onSubmit={handleCreate} className="flex flex-col gap-3">
            <div className="flex gap-3">
              <input
                className="flex-1 bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-sm placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="First name"
                value={form.firstName}
                onChange={(e) =>
                  setForm({ ...form, firstName: e.target.value })
                }
                required
              />
              <input
                className="flex-1 bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-sm placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="Last name"
                value={form.lastName}
                onChange={(e) => setForm({ ...form, lastName: e.target.value })}
                required
              />
            </div>
            <input
              type="email"
              className="bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-sm placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="Email address"
              value={form.email}
              onChange={(e) => setForm({ ...form, email: e.target.value })}
              required
            />
            <button
              type="submit"
              className="bg-blue-600 hover:bg-blue-500 rounded-lg px-4 py-2 text-sm font-medium transition-colors"
            >
              Add User
            </button>
          </form>
        </div>

        {/* Users list */}
        <div className="bg-gray-900 border border-gray-800 rounded-xl p-6">
          <h2 className="text-base font-semibold mb-4">
            Users{' '}
            <span className="text-gray-500 font-normal text-sm">
              ({users.length})
            </span>
          </h2>

          {loading ? (
            <p className="text-gray-500 text-sm">Connecting to API…</p>
          ) : users.length === 0 ? (
            <p className="text-gray-500 text-sm">No users yet.</p>
          ) : (
            <ul className="divide-y divide-gray-800">
              {users.map((u) => (
                <li key={u.id} className="py-4">
                  {editingId === u.id ? (
                    <div className="flex flex-col gap-2">
                      <div className="flex gap-2">
                        <input
                          className="flex-1 bg-gray-800 border border-gray-700 rounded-lg px-3 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                          value={editForm.firstName}
                          onChange={(e) =>
                            setEditForm({
                              ...editForm,
                              firstName: e.target.value,
                            })
                          }
                        />
                        <input
                          className="flex-1 bg-gray-800 border border-gray-700 rounded-lg px-3 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                          value={editForm.lastName}
                          onChange={(e) =>
                            setEditForm({
                              ...editForm,
                              lastName: e.target.value,
                            })
                          }
                        />
                      </div>
                      <input
                        type="email"
                        className="bg-gray-800 border border-gray-700 rounded-lg px-3 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                        value={editForm.email}
                        onChange={(e) =>
                          setEditForm({ ...editForm, email: e.target.value })
                        }
                      />
                      <div className="flex gap-2">
                        <button
                          onClick={() => handleUpdate(u.id)}
                          className="bg-green-700 hover:bg-green-600 rounded-lg px-3 py-1.5 text-xs font-medium transition-colors"
                        >
                          Save
                        </button>
                        <button
                          onClick={() => setEditingId(null)}
                          className="bg-gray-700 hover:bg-gray-600 rounded-lg px-3 py-1.5 text-xs font-medium transition-colors"
                        >
                          Cancel
                        </button>
                      </div>
                    </div>
                  ) : (
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="text-sm font-medium">
                          {u.firstName} {u.lastName}
                        </p>
                        <p className="text-gray-400 text-xs mt-0.5">
                          {u.email}
                        </p>
                      </div>
                      <div className="flex items-center gap-2">
                        <span className="text-gray-600 text-xs font-mono mr-2">
                          #{u.id}
                        </span>
                        <button
                          onClick={() => startEdit(u)}
                          className="bg-gray-700 hover:bg-gray-600 rounded-lg px-3 py-1.5 text-xs font-medium transition-colors"
                        >
                          Edit
                        </button>
                        <button
                          onClick={() => handleDelete(u.id)}
                          className="bg-red-900/60 hover:bg-red-800 rounded-lg px-3 py-1.5 text-xs font-medium transition-colors text-red-300"
                        >
                          Delete
                        </button>
                      </div>
                    </div>
                  )}
                </li>
              ))}
            </ul>
          )}
        </div>
      </div>
    </main>
  )
}
