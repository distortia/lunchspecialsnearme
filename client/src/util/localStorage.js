const addItem = (key, obj) => {
  window.localStorage.setItem(key, JSON.stringify(obj));
};

const removeItem = (key) => {
  window.localStorage.removeItem(key);
};

const getItem = (key) => {
  const item = JSON.parse(window.localStorage.getItem(key));
  if (key === 'domain') { return item; } // Returns the item if all we need is the domain
  const today = new Date();
  const exp = item && item.exp ? new Date(item.exp * 1000.0) : null;
  if (exp && exp > today) {
    return item;
  }
  removeItem(key);
  return null;
};

export default {
  addItem, getItem, removeItem,
};
