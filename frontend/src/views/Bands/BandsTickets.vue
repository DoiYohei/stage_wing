<template>
  <div>
    <h1>Tickets</h1>
    <v-container>
      <v-row>
        <v-col
          md="4"
          offset-md="4"
          v-for="(ticket, index) in tickets"
          :key="index"
        >
          <span>
            {{ $dayjs(ticket.event.open_at).format("YYYY MMM DD") }}
            : {{ ticket.event.name }}
          </span>
          <span>/ {{ ticket.audience }}</span>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  props: {
    id: {
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
    const res = await this.$axios.get(`/bands/${this.id}/tickets`, token);
    this.tickets = res.data;
  },
};
</script>
