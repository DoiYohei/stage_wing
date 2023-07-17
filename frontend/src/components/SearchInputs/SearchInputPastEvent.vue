<template>
  <v-card :color="color" max-width="207" flat>
    <v-card-actions>
      <v-checkbox
        v-model="showPast"
        label="過去のイベントを表示"
        dense
        hide-details
      />
    </v-card-actions>
  </v-card>
</template>

<script>
export default {
  props: {
    value: {
      type: Boolean,
      require: true,
    },
    color: {
      type: String,
      default: "",
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
