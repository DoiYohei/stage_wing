<template>
  <v-pagination
    v-if="$page.displayContents.length"
    @input="changePage"
    v-model="$page.current"
    :length="$page.total"
    color="grey darken-3"
    total-visible="7"
  />
</template>

<script>
export default {
  methods: {
    changePage() {
      this.$emit("change-page");
    },
  },
};
</script>
