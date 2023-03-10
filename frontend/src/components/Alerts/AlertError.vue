<template>
  <v-alert :value="value" type="error" dense outlined>
    {{ text }}
  </v-alert>
</template>

<script>
export default {
  props: {
    value: {
      type: Boolean,
      require: true,
    },
    text: {
      type: String,
      require: true,
    },
  },
};
</script>
