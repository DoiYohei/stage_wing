<template>
  <v-card-actions>
    <vue-ctk-date-time-picker
      v-model="dateInput"
      format="YYYY-MM-DD"
      label="開催日で検索"
      color="grey"
      auto-close
      dark
      no-button-now
      only-date
    />
  </v-card-actions>
</template>

<script>
export default {
  props: {
    value: {
      type: String,
      require: true,
    },
  },
  computed: {
    dateInput: {
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
