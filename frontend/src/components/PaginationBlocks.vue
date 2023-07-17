<template>
  <v-pagination
    v-if="totalPage"
    v-model="page"
    :length="totalPage"
    color="grey darken-3"
    total-visible="7"
  />
</template>

<script>
export default {
  props: {
    value: {
      type: Number,
      require: true,
    },
    contents: {
      type: Array,
      require: true,
    },
    rows: {
      type: Number,
      require: true,
    },
  },
  computed: {
    page: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
    totalPage() {
      return Math.ceil(this.contents.length / this.rows);
    },
  },
};
</script>
