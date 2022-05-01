<template>
  <FormBand v-model="band" @submit-forms="patchBand">
    <template #page-title>Profile 編集</template>
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
    };
  },
  async created() {
    const res = await this.$axios.get(`/bands/${this.id}/edit`, this.headers);
    this.band = res.data;
  },
  computed: {
    ...mapGetters(["headers"]),
  },
  methods: {
    async patchBand(image) {
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
      this.$router.replace(`/bands/${this.id}`);
    },
  },
};
</script>
