<template>
  <div>
    <h1>アカウント情報編集</h1>
    <v-container>
      <v-row>
        <v-col md="2" offset-md="5">
          <v-text-field v-model="audience.name" label="Name" />
        </v-col>
        <v-col md="2" offset-md="5">
          <v-text-field v-model="audience.email" label="Email" />
        </v-col>
        <v-col cols="12">
          <v-btn elevation="4" @click="patchAudience">更新する</v-btn>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  props: ["userId"],
  data() {
    return {
      audience: {},
    };
  },
  computed: {
    ...mapGetters(["headers"]),
  },
  methods: {
    async patchAudience() {
      const formData = new FormData();
      formData.append("name", this.audience.name);
      formData.append("email", this.audience.email);
      await this.$axios.patch("/audiences", formData, this.headers);
      this.$router.replace(`/audiences/${this.userId}`);
    },
  },
  async created() {
    const res = await this.$axios.get(
      `/audiences/${this.userId}`,
      this.headers
    );
    this.audience = res.data;
  },
};
</script>
