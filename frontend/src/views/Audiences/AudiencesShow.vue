<template>
  <div>
    <h1>My Page</h1>
    <v-container>
      <v-row>
        <v-col><img :src="audience.image.url" /></v-col>
        <v-col>
          <div>{{ audience.name }}</div>
        </v-col>
        <v-col>
          <router-link :to="`/audiences/${userId}/edit`">編集</router-link>
        </v-col>
        <v-col>
          <v-btn @click="deleteAudience">退会する</v-btn>
        </v-col>
        <v-col>
          <router-link>お気に入り</router-link>
        </v-col>
        <v-col>
          <router-link>取り置きしているチケット</router-link>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  props: ["userId"],
  data() {
    return {
      audience: {},
    };
  },
  async created() {
    const token = { headers: this.$store.getters.token };
    const res = await this.$axios.get(`/audiences/${this.userId}`, token);
    this.audience = res.data;
  },
  methods: {
    async deleteAudience() {
      const token = { headers: this.$store.getters.token };
      this.$store.dispatch("deleteAudience", token);
    },
  },
};
</script>
