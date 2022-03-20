<template>
  <v-card flat>
    <v-list color="#121212">
      <v-list-item-group>
        <v-list-item
          v-for="(item, index) in cardItems"
          :key="index"
          :to="item.path"
        >
          <v-list-item-content>
            <v-card-title v-text="item.text" />
          </v-list-item-content>
        </v-list-item>
        <slot />
      </v-list-item-group>
    </v-list>
  </v-card>
</template>

<script>
export default {
  props: {
    cardItems: {
      type: Array,
      require: true,
    },
  },
};
</script>
