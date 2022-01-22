<template>
  <v-pagination
    v-if="$page.displayContents.length"
    @input="changePage"
    v-model="$page.current"
    :length="$page.total"
    total-visible="7"
  />
</template>

<script>
export default {
  props: {
    moldDisplay: {
      type: Function,
      required: true,
    },
  },
  methods: {
    changePage() {
      this.moldDisplay();
    },
  },
};
</script>
