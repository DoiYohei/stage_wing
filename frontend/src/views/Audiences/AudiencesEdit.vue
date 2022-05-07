<template>
  <FormAudience v-model="audience" @submit-forms="patchAudience">
    <template #page-title>アカウント編集</template>
    <template #error-text>
      更新できませんでした。入力事項をご確認の上、もう一度お試しください。
    </template>
    <template #btn-text>更新する</template>
  </FormAudience>
</template>

<script>
import { mapGetters } from "vuex";
import FormAudience from "@/components/Forms/FormAudience";

export default {
  components: {
    FormAudience,
  },
  props: ["id"],
  data() {
    return {
      audience: {},
    };
  },
  async created() {
    const res = await this.$axios
      .get(`/audiences/${this.id}/edit`, this.headers)
      .catch((error) => error.response.success);
    if (res) {
      this.audience = res.data;
      this.audience.isError = false;
    } else this.$router.replace("/");
  },
  computed: {
    ...mapGetters(["headers"]),
  },
  methods: {
    async patchAudience(image) {
      const formData = new FormData();
      formData.append("name", this.audience.name);
      formData.append("email", this.audience.email);
      if (image) formData.append("image", image);
      const res = await this.$axios
        .patch("/audiences", formData, this.headers)
        .catch((error) => {
          return error.response.success;
        });
      if (res) {
        const userType = "audiences";
        this.$store.dispatch("setAuthData", { res, userType });
        this.$router.replace("/");
      } else this.audience.isError = true;
    },
  },
};
</script>
