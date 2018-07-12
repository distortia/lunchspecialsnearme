<template>
  <b-list-group>
    <b-list-group-item v-for="(restaurant, index) in restaurants" :key="index" class="flex-column align-items-start">
      <div class="d-flex w-100 justify-content-between">
        <h5 class="mb-1">{{index + 1}}: {{restaurant.name}}</h5>
        <small>{{restaurant.vicinity}}</small>
      </div>
      <p class="mb-1">
        <div style="display: block;">
          <b-badge pill :variant="ratingVariant(restaurant.rating)">
            Rating: {{restaurant.rating}} <i class="fa fa-star" aria-hidden="true"></i>
          </b-badge>
          <b-badge pill :variant="expensivityVariant(restaurant.price_level)">Price Level: {{restaurant.price_level | expensivity }}</b-badge>
          <b-badge pill :variant="openNowVariant(restaurant.opening_hours)">{{ openNowText(restaurant.opening_hours) }}</b-badge>
        </div>
        <div class="button-group">
          <b-button :href="`https://www.google.com/maps/place/${restaurant.vicinity}`"
                    target="_blank" 
                    class="card-link"
                    variant="outline-primary">
            <i class="fa fa-map-marker" aria-hidden="true"></i>
            Directions
          </b-button>
           <b-button variant="outline-info" @click="$root.$emit('show-restaurant-modal', restaurant)">
              <i class="fa fa-info-circle" aria-hidden="true"></i>
              Info
           </b-button>
         </div>
      </p>
    </b-list-group-item>
  </b-list-group>
</template>

<script>
export default {

  name: 'restaurantList',

  data () {
    return {

    }
  },
  props: ['restaurants'],
  methods: {
  }
}
</script>

<style lang="scss">
</style>