<template>
  <v-dialog
    v-model="isShow"
    max-width="1000"
    overlay-color="white"
    overlay-opacity="0.2"
    persistent
  >
    <v-card color="#121212" class="text-center pt-10 pb-0">
      <v-card-text class="white--text">{{ text }}</v-card-text>
      <v-card-text>
        <v-btn @click="closeDialog" color="grey darken-3" small>OK</v-btn>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  props: {
    isShow: {
      type: Boolean,
      require: true,
    },
    text: {
      type: String,
      require: true,
    },
  },
  methods: {
    closeDialog() {
      this.$emit("close-dialog");
    },
  },
};
</script>
