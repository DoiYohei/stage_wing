<template>
  <FormBand v-model="band" @submit-forms="signUpBand">
    <template #page-title>SIGNUP (BAND)</template>
    <template #error-text>
      登録できませんでした。入力事項をご確認の上、もう一度お試しください。
    </template>
    <template #btn-text>Sign Up</template>
  </FormBand>
</template>

<script>
import FormBand from "@/components/Forms/FormBand";

export default {
  components: {
    FormBand,
  },
  data() {
    return {
      band: {
        name: "",
        email: "",
        password: "",
        profile: "",
        website: "",
        twitter: "",
        image: null,
        isError: false,
      },
    };
  },
  methods: {
    async signUpBand(image) {
      const formData = new FormData();
      formData.append("name", this.band.name);
      formData.append("email", this.band.email);
      formData.append("password", this.band.password);
      formData.append("image", image);
      formData.append("profile", this.band.profile);
      formData.append("website", this.band.website);
      formData.append("twitter", this.band.twitter);
      const res = await this.$store.dispatch("signupBand", formData);
      if (!res) this.band.isError = true;
    },
  },
};
</script>
