<template>
  <FormAudience
    v-model="audience"
    :is-error="isError"
    @submit-forms="patchAudience"
  >
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
      isError: false,
    };
  },
  async created() {
    try {
      if (this.id !== this.audienceId) throw { response: "status 401" };
      const res = await this.$axios.get(
        `/audiences/${this.id}/edit`,
        this.headers
      );
      this.audience = res.data;
    } catch (error) {
      if (error.response) this.$router.replace("/");
    }
  },
  computed: {
    ...mapGetters(["audienceId", "headers"]),
  },
  methods: {
    async patchAudience(image) {
      try {
        const formData = new FormData();
        formData.append("name", this.audience.name);
        formData.append("email", this.audience.email);
        if (image) formData.append("image", image);
        const res = await this.$axios.patch(
          "/audiences",
          formData,
          this.headers
        );
        const userType = "audiences";
        this.$store.dispatch("setAuthData", { res, userType });
      } catch (error) {
        if (error.response) this.isError = true;
      }
    },
  },
};
</script>
