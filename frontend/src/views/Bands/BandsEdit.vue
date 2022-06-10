<template>
  <FormBand v-model="band" :is-error="isError" @submit-forms="patchBand">
    <template #page-title>Profile 編集</template>
    <template #error-text>
      更新できませんでした。入力事項をご確認の上、もう一度お試しください。
    </template>
    <template #btn-text>更新する</template>
  </FormBand>
</template>

<script>
import { mapGetters } from "vuex";
import FormBand from "@/components/Forms/FormBand";

export default {
  components: {
    FormBand,
  },
  props: ["id"],
  data() {
    return {
      band: {},
      isError: false,
    };
  },
  async created() {
    try {
      if (this.id !== this.bandId) throw { response: "status 401" };
      const res = await this.$axios.get(`/bands/${this.id}/edit`, this.headers);
      this.band = res.data;
    } catch (error) {
      if (error.response) this.$router.replace("/");
    }
  },
  computed: {
    ...mapGetters(["bandId", "headers"]),
  },
  methods: {
    async patchBand(image) {
      try {
        const formData = new FormData();
        formData.append("name", this.band.name);
        formData.append("email", this.band.email);
        formData.append("profile", this.band.profile);
        formData.append("website", this.band.website);
        formData.append("twitter", this.band.twitter);
        if (image) formData.append("image", image);
        const res = await this.$axios.patch("/bands", formData, this.headers);
        const userType = "bands";
        this.$store.dispatch("setAuthData", { res, userType });
      } catch (error) {
        if (error.response) this.isError = true;
      }
    },
  },
};
</script>
