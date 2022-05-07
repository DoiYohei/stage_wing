<template>
  <v-card-actions>
    <DatePicker
      v-model="dateInput"
      format="YYYY-MMM-DD"
      value-type="YYYY-MM-DD"
      placeholder="開催日で検索"
      confirm
    />
  </v-card-actions>
</template>

<script>
import DatePicker from "vue2-datepicker";
import "vue2-datepicker/index.css";

export default {
  components: {
    DatePicker,
  },
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
