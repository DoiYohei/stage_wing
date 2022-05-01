<template>
  <FormAudience v-model="audience" @submit-forms="signUpAudience">
    <template #page-title>SIGNUP (AUDIENCE)</template>
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
    };
  },
  methods: {
    signUpAudience(image) {
      const formData = new FormData();
      formData.append("name", this.audience.name);
      formData.append("email", this.audience.email);
      formData.append("password", this.audience.password);
      formData.append("image", image);
      this.$store.dispatch("signupAudience", formData);
    },
  },
};
</script>
