<template>
  <div>
    <h1>取り置きしているチケット</h1>
    <v-container>
      <v-row>
        <v-col
          md="4"
          offset-md="4"
          v-for="(ticket, index) in tickets"
          :key="index"
        >
          <router-link :to="`/events/${ticket.event.id}`">
            {{ $dayjs(ticket.event.open_at).format("YYYY MMM DD") }}:
            {{ ticket.event.name }}
          </router-link>
          <router-link :to="`/bands/${ticket.band.id}`">
            / {{ ticket.band.name }}
          </router-link>
          <v-btn @click="deleteTicket(ticket.event.id, ticket.id)"
            >キャンセルする
          </v-btn>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  props: {
    userId: {
      type: String,
      require: true,
    },
  },
  data() {
    return {
      tickets: {},
    };
  },
  async created() {
    const token = { headers: this.$store.getters.token };
    const res = await this.$axios.get(
      `/audiences/${this.userId}/tickets`,
      token
    );
    this.tickets = res.data;
  },
  methods: {
    deleteTicket(eventId, ticketId) {
      const token = { headers: this.$store.getters.token };
      this.$axios.delete(`/events/${eventId}/tickets/${ticketId}`, token);
    },
  },
};
</script>
