<template>
  <v-card-actions>
    <v-checkbox
      v-model="showPast"
      label="過去のイベントを表示"
      dense
      hide-details
    />
  </v-card-actions>
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
    showPast: {
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
