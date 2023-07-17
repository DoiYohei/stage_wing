<template>
  <v-btn :to="pass" light fab right bottom fixed>
    <v-icon dark>mdi-plus</v-icon>
  </v-btn>
</template>

<script>
export default {
  props: {
    pass: {
      type: String,
      require: true,
    },
  },
};
</script>
