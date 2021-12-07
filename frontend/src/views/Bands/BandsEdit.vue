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
        <v-col md="2" offset-md="5">
          <v-file-input
            v-model="image"
            @change="fetchBandUrl"
            @blur="fetchOriginal"
            label="プロフィール画像を変更する"
            chips
          />
        </v-col>
        <v-col md="2">
          <v-img v-if="bandUrl" :src="bandUrl" />
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
      image: null,
      bandUrl: "",
    };
  },
  async created() {
    const res = await this.$axios.get(`/bands/${this.id}`);
    this.band = res.data;
    this.bandUrl = res.data.image;
  },
  methods: {
    fetchBandUrl(file) {
      if (file !== undefined && file !== null) {
        if (file.name.lastIndexOf(".") <= 0) {
          return;
        } else {
          const fr = new FileReader();
          fr.readAsDataURL(file);
          fr.addEventListener("load", () => {
            this.bandUrl = fr.result;
          });
        }
      } else {
        this.bandUrl = "";
      }
    },
    fetchOriginal() {
      if (!this.bandUrl) {
        this.bandUrl = this.band.image;
      }
    },
    async patchBand() {
      const token = { headers: this.$store.getters.token };
      const formData = new FormData();
      formData.append("name", this.band.name);
      formData.append("email", this.band.email);
      if (this.image) formData.append("image", this.image);
      await this.$axios.patch("/auth/account/edit", formData, token);
      this.$router.replace(`/bands/${this.id}`);
    },
  },
  watch: {
    image() {
      if (!this.bandUrl) {
        this.bandUrl = this.band.image;
      }
    },
  },
};
</script>
