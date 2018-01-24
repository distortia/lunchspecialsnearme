import localStorage from '../util/localStorage';

const addUser = (userData) => {
  localStorage.addItem("user", userData);
}

const isLoggedIn = () => {
  return getUser() !== null;
}

const getUser = () => {
  return getKey("user");
}

const getJwt = () => {
  return getKey("jwt");
}

const getKey = (key) => {
  const data = localStorage.getItem("user");
  return data ? data[key] : null;
}

const removeUser = () => {
  localStorage.removeItem("user");
}

export default {
  addUser, getUser, getJwt, isLoggedIn, removeUser
};
