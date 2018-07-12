const specialsMixin = {
  methods: {
    ratingVariant(rating) {
      if (rating >= 3.5) {
        return 'success'
      } else if (rating >= 2.5 && rating <= 3.4) {
        return 'warning'
      } else {
        return 'danger'
      }
    },
    expensivityVariant(price_level) {
      switch (price_level) {
        case 0:
          return 'success'
        case 1:
          return 'success'
        case 2:
          return 'success'
        case 3:
          return 'warning'
        case 4:
          return 'danger'
        case undefined:
          return 'warning'
        case null:
          return 'warning'
        default: 'warning'
      }
    },
    openNowVariant(opening_hours) {
      if (opening_hours === undefined) {
        return 'warning'
      } else if(opening_hours.open_now) {
        return 'info'
      } else {
        return 'danger'
      }
    }, 
    openNowText(opening_hours) {
      if (opening_hours === undefined) {
        return 'Unknown Hours'
      } else if(opening_hours.open_now) {
        return 'Open Now'
      } else {
        return 'Closed Now'
      }    
    }
  },
}

export default specialsMixin