<template>
  <FormAudience v-model="audience" @submit-forms="patchAudience">
    <template #page-title>アカウント編集</template>
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
    const res = await this.$axios.get(
      `/audiences/${this.id}/edit`,
      this.headers
    );
    this.audience = res.data;
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
      await this.$axios.patch("/audiences", formData, this.headers);
      this.$router.replace(`/audiences/${this.id}`);
    },
  },
};
</script>
