<template>
  <v-container>
    <v-row>
      <v-col class="text-h5">Signup</v-col>
    </v-row>
    <CardAudienceForms
      v-model="audience"
      btn-text="Sign Up"
      :delivery-forms="signUpAudience"
    />
  </v-container>
</template>

<script>
import CardAudienceForms from "@/components/Cards/CardAudienceForms";

export default {
  components: {
    CardAudienceForms,
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
