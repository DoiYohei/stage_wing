<template>
  <FormAudience
    v-model="audience"
    :is-error="isError"
    @submit-forms="signUpAudience"
  >
    <template #page-title>SIGNUP (AUDIENCE)</template>
    <template #error-text>
      登録できませんでした。入力事項をご確認の上、もう一度お試しください。
    </template>
    <template #btn-text>Sign Up</template>
  </FormAudience>
</template>

<script>
import FormAudience from "@/components/Forms/FormAudience";

export default {
  components: {
    FormAudience,
  },
  data() {
    return {
      audience: {
        name: "",
        email: "",
        password: "",
      },
      isError: false,
    };
  },
  methods: {
    async signUpAudience(image) {
      try {
        const formData = new FormData();
        formData.append("name", this.audience.name);
        formData.append("email", this.audience.email);
        formData.append("password", this.audience.password);
        formData.append("image", image);
        const res = await this.$axios.post("/audiences", formData);
        const userType = "audiences";
        this.$store.dispatch("setAuthData", { res, userType });
      } catch (error) {
        if (error.response) this.isError = true;
      }
    },
  },
};
</script>
