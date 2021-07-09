<template>
  <div>
    <h1>アカウント情報編集</h1>
    <v-container>
      <v-row>
        <v-col md="2" offset-md="5">
          <v-text-field v-model="band.name" label="Band Name" />
        </v-col>
        <v-col md="2" offset-md="5">
          <v-text-field v-model="band.email" label="Email" />
        </v-col>
        <v-col cols="12">
          <v-btn elevation="4" @click="patchBand">更新する</v-btn>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  props: ["id"],
  data() {
    return {
      band: {},
    };
  },
  methods: {
    async patchBand() {
      const token = { headers: this.$store.getters.token };
      const formData = new FormData();
      formData.append("name", this.band.name);
      formData.append("email", this.band.email);
      await this.$axios.patch("/auth/account/edit", formData, token);
      this.$router.replace(`/bands/${this.id}`);
    },
  },
  async created() {
    const res = await this.$axios.get(`/bands/${this.id}`);
    this.band = res.data;
  },
};
</script>
