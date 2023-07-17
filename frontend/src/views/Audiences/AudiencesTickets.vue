<template>
  <v-container :fluid="$vuetify.breakpoint.lgAndDown" class="px-0 px-sm-3">
    <v-row>
      <v-col :cols="cols" :offset="offset" class="px-0 px-sm-3">
        <v-card class="pa-4" flat>
          <v-card-title class="font-weight-bold">
            取り置きしているチケット
          </v-card-title>
          <v-card flat class="px-2">
            <SearchInputPastEvent v-model="showPast" />
            <v-data-table
              :headers="table_headers"
              :items="displayTickets"
              hide-default-footer
              mobile-breakpoint="960"
            >
              <template #[`item.date`]="{ item }">
                {{ $dayjs(item.date).format("YYYY年MM月DD日") }}
              </template>
              <template #[`item.event_name`]="{ item }">
                <router-link :to="`/events/${item.event_id}`">
                  {{ item.event_name }}
                </router-link>
              </template>
              <template #[`item.band_name`]="{ item }">
                <router-link :to="`/bands/${item.band_id}`">
                  {{ item.band_name }}
                </router-link>
              </template>
              <template #[`item.delete`]="{ item }">
                <v-icon @click="openDialog(item)">mdi-delete</v-icon>
              </template>
            </v-data-table>
            <DialogYesNo
              v-model="dialog"
              :question="dialogText"
              @select-excution="deleteTicket"
              @close-dialog="closeDialog"
            />
          </v-card>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import SearchInputPastEvent from "@/components/SearchInputs/SearchInputPastEvent";
import DialogYesNo from "@/components/Dialogs/DialogYesNo";
import { mapGetters } from "vuex";
import { respondCols } from "@/utils/grids";
import { goHome } from "@/utils/routers";
import { popFutureItems } from "@/utils/searches";
import { deleteTicket } from "@/utils/tickets";

export default {
  components: {
    SearchInputPastEvent,
    DialogYesNo,
  },
  props: ["id"],
  data() {
    return {
      table_headers: [
        {
          text: "Date",
          value: "date",
        },
        {
          text: "Event",
          value: "event_name",
        },
        {
          text: "Band",
          value: "band_name",
        },
        {
          text: "",
          value: "delete",
          sortable: false,
        },
      ],
      futureTickets: [],
      allTickets: [],
      selectedTicket: {},
      showPast: false,
      dialog: false,
    };
  },
  async created() {
    if (Number(this.id) !== this.audienceId) goHome();
    try {
      const res = await this.$axios.get(
        `/audiences/${this.id}/tickets`,
        this.headers
      );

      // 長いEvent名、Band名を短縮。
      this.allTickets = res.data.map((ticket) => {
        ticket.event_name = this.shortenName(ticket.event_name);
        ticket.band_name = this.shortenName(ticket.band_name);
        return ticket;
      });

      // 未開催EventのTicketを抽出。
      this.futureTickets = popFutureItems(this.allTickets);
    } catch (error) {
      if (error.response) goHome();
    }
  },
  computed: {
    ...mapGetters(["audienceId", "headers"]),
    cols() {
      return respondCols(this.$vuetify.breakpoint, 8, 10, 12, 12, 12);
    },
    offset() {
      return respondCols(this.$vuetify.breakpoint, 2, 1, 0, 0, 0);
    },
    displayTickets() {
      return this.showPast ? this.allTickets : this.futureTickets;
    },
    dialogText() {
      const eventName = this.selectedTicket.event_name;
      return eventName ? `${eventName}のチケット取り置きをやめますか？` : "";
    },
  },
  methods: {
    shortenName(name) {
      let total = 0;
      let over = 0;
      for (let i = 0; i < name.length; i++) {
        total += name[i].match(/[ -~]/) ? 1 : 2;
        if (total > 42 && !over) over = i;
      }
      if (total > 42) name = name.slice(0, over) + "...";
      return name;
    },
    deleteTicket() {
      deleteTicket(this.selectedTicket.ticket_id);
      this.closeDialog();
    },
    openDialog(item) {
      this.selectedTicket = item;
      this.dialog = true;
    },
    closeDialog() {
      this.selectedTicket = "";
      this.dialog = false;
    },
  },
};
</script>
