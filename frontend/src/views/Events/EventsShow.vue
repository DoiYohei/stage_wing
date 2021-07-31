<template>
  <div>
    <template v-if="event.owner">
      <div>{{ event.owner.name }}</div>
    </template>
    <p v-else>作成者は退会しました</p>
    <template v-if="isEventOwner">
      <router-link :to="`/events/${id}/edit`"
        >イベント情報を編集する</router-link
      >
      <button @click="deleteEvent">削除する</button>
    </template>
    <div>{{ event.name }}</div>
    <img :src="event.flyer" />
    <div>Open: {{ $dayjs(event.open_at).format("YYYY MMM DD - hh:mm") }}</div>
    <div>Start: {{ $dayjs(event.start_at).format("YYYY MMM DD - hh:mm") }}</div>
    <div>{{ event.place }}</div>
    <div>{{ event.content }}</div>
    <p>Lineup:</p>
    <template v-if="lineup.performers">
      <div v-for="(performer, index) in lineup.performers" :key="index">
        <router-link :to="`/bands/${performer.id}`">{{
          performer.name
        }}</router-link>
      </div>
    </template>
    <template v-if="event.unregistered_performers">
      <div>/ {{ event.unregistered_performers }}</div>
    </template>
    <template v-if="isEventOwner">
      <router-link :to="`/events/${id}/lineup/edit`"
        >Lineupを編集する</router-link
      >
    </template>
  </div>
</template>

<script>
export default {
  props: ["id"],
  data() {
    return {
      event: {},
      lineup: {},
    };
  },
  computed: {
    isEventOwner() {
      return this.$store.getters.currentUserId === this.event.owner_id;
    },
  },
  methods: {
    async deleteEvent() {
      const token = { headers: this.$store.getters.token };
      await this.$axios.delete(`/events/${this.id}`, token);
      this.$router.replace("/");
    },
  },
  async created() {
    const eventRes = await this.$axios.get(`/events/${this.id}`);
    this.event = eventRes.data;
    const lineupRes = await this.$axios.get(`/events/${this.id}/lineups`);
    this.lineup = lineupRes.data;
  },
};
</script>
