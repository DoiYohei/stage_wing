<template>
  <v-container>
    <v-row>
      <v-col class="text-h5">アカウント情報の編集</v-col>
    </v-row>
    <CardAudienceForms
      v-model="audience"
      btn-text="更新する"
      :delivery-forms="patchAudience"
    />
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import CardAudienceForms from "@/components/Cards/CardAudienceForms";

export default {
  components: {
    CardAudienceForms,
  },
  props: ["userId"],
  data() {
    return {
      audience: {},
    };
  },
  async created() {
    const res = await this.$axios.get(
      `/audiences/${this.userId}/edit`,
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
      this.$router.replace(`/audiences/${this.userId}`);
    },
  },
};
</script>
