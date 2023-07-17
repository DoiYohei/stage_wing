<template>
  <v-row>
    <v-col>
      <v-card color="#121212" flat>
        <v-card-title class="pb-0">
          <v-spacer />
          {{ title }}
          <v-spacer />
        </v-card-title>
      </v-card>
    </v-col>
  </v-row>
</template>

<script>
export default {
  props: {
    title: {
      type: String,
      require: true,
    },
  },
};
</script>
