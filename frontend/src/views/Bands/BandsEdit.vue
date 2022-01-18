<template>
  <v-container>
    <v-row>
      <v-col class="text-h5">Profile編集</v-col>
    </v-row>
    <v-row>
      <v-col>
        <v-card>
          <v-col class="d-flex justify-md-start flex-wrap">
            <v-col md="7" sm="12">
              <v-img v-if="imageUrl" :src="imageUrl" />
            </v-col>
            <v-col class="text-left pb-0">
              <v-card-text>
                <v-file-input
                  v-model="image"
                  @change="fetchImageUrl"
                  @blur="fetchOriginal"
                  label="プロフィール画像を変更する"
                  chips
                />
              </v-card-text>
              <v-card-text>
                <v-text-field v-model="band.name" label="Band Name" />
                <v-text-field v-model="band.email" label="Email" />
                <v-text-field v-model="band.website" label="ホームページURL" />
                <v-text-field v-model="band.twitter" label="Twitter URL" />
              </v-card-text>
              <v-card-text>
                <v-textarea
                  v-model="band.profile"
                  label="Profile"
                  auto-grow
                  filled
                />
              </v-card-text>
              <v-card-actions>
                <v-btn width="100%" elevation="4" @click="patchBand">
                  更新する
                </v-btn>
              </v-card-actions>
            </v-col>
          </v-col>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  props: ["id"],
  data() {
    return {
      band: {},
      image: null,
      imageUrl: "",
    };
  },
  async created() {
    const res = await this.$axios.get(`/bands/${this.id}/edit`, this.headers);
    this.band = res.data;
    this.imageUrl = res.data.image.url;
  },
  computed: {
    ...mapGetters(["headers"]),
  },
  methods: {
    fetchImageUrl(file) {
      if (file !== undefined && file !== null) {
        if (file.name.lastIndexOf(".") <= 0) {
          return;
        } else {
          const fr = new FileReader();
          fr.readAsDataURL(file);
          fr.addEventListener("load", () => {
            this.imageUrl = fr.result;
          });
        }
      } else {
        this.imageUrl = "";
      }
    },
    fetchOriginal() {
      if (!this.imageUrl) {
        this.imageUrl = this.band.image.url;
      }
    },
    async patchBand() {
      const formData = new FormData();
      formData.append("name", this.band.name);
      formData.append("email", this.band.email);
      formData.append("profile", this.band.profile);
      formData.append("website", this.band.website);
      formData.append("twitter", this.band.twitter);
      if (this.image) formData.append("image", this.image);
      await this.$axios.patch("/auth/account/edit", formData, this.headers);
      this.$router.replace(`/bands/${this.id}`);
    },
  },
  watch: {
    image() {
      if (!this.imageUrl) {
        this.imageUrl = this.band.image.url;
      }
    },
  },
};
</script>
