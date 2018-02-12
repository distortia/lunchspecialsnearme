const mobileMixin = {
  methods: {
    isMobile() {
      return document.documentElement.clientWidth < 992
    },
  },
}

export default mobileMixin