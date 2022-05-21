<template>
  <v-dialog v-model="dialog" width="500">
    <v-card outlined class="text-center">
      <v-card-text class="white--text mt-7"><slot /></v-card-text>
      <v-card-text>
        <v-btn @click="dialog = false" color="grey darken-3" small>close</v-btn>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  props: {
    value: {
      type: Boolean,
      require: true,
    },
  },
  computed: {
    dialog: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
  },
};
</script>
