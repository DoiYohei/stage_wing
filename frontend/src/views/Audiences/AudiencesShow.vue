<template>
  <div>
    <h1>My Page</h1>
    <v-container>
      <v-row>
        <v-col><img :src="audience.image" /></v-col>
        <v-col>
          <div>{{ audience.name }}</div>
        </v-col>
        <v-col>
          <router-link :to="`/audiences/${userId}/edit`">編集</router-link>
        </v-col>
        <v-col>
          <v-btn @click="deleteAccount">退会する</v-btn>
        </v-col>
        <v-col>
          <router-link to="/liked_posts">お気に入り</router-link>
        </v-col>
        <v-col>
          <router-link :to="`/audiences/${userId}/tickets`"
            >取り置きしているチケット
          </router-link>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import { mapActions } from "vuex";

export default {
  props: {
    userId: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      audience: {},
    };
  },
  async created() {
    const res = await this.$axios.get(
      `/audiences/${this.userId}`,
      this.headers
    );
    this.audience = res.data;
  },
  computed: {
    ...mapGetters(["headers"]),
  },
  methods: {
    ...mapActions(["deleteAccount"]),
  },
};
</script>
