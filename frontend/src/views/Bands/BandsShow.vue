<template>
  <div>
    <router-link :to="`/bands/${id}/posts`">Posts</router-link>
    <div>{{ band.name }}</div>
    <div v-if="band.profile">
      <iframe :src="band.profile"></iframe>
    </div>
    <img :src="band.image" />
    <template v-if="isMyPage">
      <router-link :to="`/bands/${id}/edit`">編集する</router-link>
      <button @click="deleteBand">削除する</button>
    </template>
    <div>LIVEスケジュール</div>
    <template v-if="band.performing_events">
      <div v-for="(event, index) in band.performing_events" :key="index">
        <router-link :to="`/events/${event.id}`"
          >{{ event.open_at }}: {{ event.name }}</router-link
        >
      </div>
    </template>
  </div>
</template>

<script>
export default {
  props: ["id"],
  data() {
    return {
      band: {},
    };
  },
  computed: {
    isMyPage() {
      return this.$store.getters.currentUserId === this.band.id;
    },
  },
  methods: {
    async deleteBand() {
      const token = { headers: this.$store.getters.token };
      await this.$axios.delete("/auth/account/delete", token);
      this.$router.replace("/");
    },
  },
  async created() {
    const res = await this.$axios.get(`/bands/${this.id}`);
    this.band = res.data;
  },
};
</script>
