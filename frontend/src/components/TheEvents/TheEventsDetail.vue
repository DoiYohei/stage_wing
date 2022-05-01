<template>
  <v-card flat>
    <v-card flat class="d-flex grey--text text--lighten-2">
      <v-card-title>{{ event.name }}</v-card-title>
      <TheEventsOwnersMenu
        v-if="isEventOwner"
        :event-id="event.id"
        @delete-event="deleteEvent"
      />
    </v-card>
    <v-card-text class="py-0">
      Date:
      {{ $dayjs(event.open_at).format("YYYY MMM DD") }}
    </v-card-text>
    <v-card-text class="py-0">
      Open/Start:
      {{ $dayjs(event.open_at).format("hh:mm") }}/{{
        $dayjs(event.start_at).format("hh:mm")
      }}
    </v-card-text>
    <v-card-text class="py-0">Location: {{ event.place }}</v-card-text>
    <v-card-text class="py-0">Ticket: ¥{{ event.ticket_price }}</v-card-text>
    <v-card-text>
      {{ event.content }}
    </v-card-text>
    <v-col>
      <v-card tile outlined>
        <v-card-subtitle>Lineup</v-card-subtitle>
        <v-card-text>
          <v-breadcrumbs :items="lineups" divider="/" class="pt-0" />
        </v-card-text>
      </v-card>
    </v-col>
    <TheEventsTicketsShow
      v-if="isAuthenticatedAudience"
      :event="event"
      @post-ticket="postTicket"
      @delete-ticket="deleteTicket"
      class="pl-3"
    />
    <v-card-subtitle class="d-flex align-center justify-end">
      created by:
      <CardAvatar v-if="event.owner" :avatar="event.owner" class="ml-2" />
      <template v-if="!event.owner">作成者は退会しました</template>
    </v-card-subtitle>
  </v-card>
</template>

<script>
import { mapGetters } from "vuex";
import TheEventsOwnersMenu from "@/components/TheEvents/TheEventsOwnersMenu";
import TheEventsTicketsShow from "@/components/TheEvents/TheEventsTicketsShow";
import CardAvatar from "@/components/Cards/CardAvatar";

export default {
  components: {
    TheEventsOwnersMenu,
    TheEventsTicketsShow,
    CardAvatar,
  },
  props: {
    event: {
      type: Object,
      require: true,
    },
    lineups: {
      type: Array,
      require: true,
    },
  },
  computed: {
    ...mapGetters(["userId", "isAuthenticatedBand", "isAuthenticatedAudience"]),
    isEventOwner() {
      if (this.event.owner) {
        return this.isAuthenticatedBand && this.userId === this.event.owner.id;
      } else {
        return false;
      }
    },
  },
  methods: {
    deleteEvent() {
      this.$emit("delete-event");
    },
    postTicket(bandId) {
      this.$emit("post-ticket", bandId);
    },
    deleteTicket() {
      this.$emit("delete-ticket");
    },
  },
};
</script>
