<template>
  <v-container>
    <v-row>
      <v-col xl="8" offset-xl="2">
        <v-card>
          <v-card-title class="font-weight-bold pb-0">
            取り置きしているチケット
          </v-card-title>
          <CardActionsEventPastSelect v-model="showPast" class="pl-3" />
          <v-data-table
            :headers="table_headers"
            :items="displayTickets"
            hide-default-footer
          >
            <template #[`item.event.name`]="{ item }">
              <router-link :to="`/events/${item.event.id}`">
                {{ item.event.name }}
              </router-link>
            </template>
            <template #[`item.band.name`]="{ item }">
              <router-link :to="`/bands/${item.band.id}`">
                {{ item.band.name }}
              </router-link>
            </template>
            <template #[`item.delete`]="{ item }">
              <v-icon @click="openDialog(item)">mdi-delete</v-icon>
            </template>
          </v-data-table>
          <v-dialog v-model="dialog" width="45vw">
            <CardDialog
              :dialog-text="dialogText"
              @select-excution="deleteTicket"
              @close-dialog="closeDialog"
            />
          </v-dialog>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import CardActionsEventPastSelect from "@/components/CardActions/CardActionsEventPastSelect";
import CardDialog from "@/components/Cards/CardDialog";

export default {
  components: {
    CardActionsEventPastSelect,
    CardDialog,
  },
  props: ["id"],
  data() {
    return {
      table_headers: [
        {
          text: "Date",
          value: "event.open_at",
        },
        {
          text: "Event",
          value: "event.name",
        },
        {
          text: "Band",
          value: "band.name",
        },
        {
          text: "",
          value: "delete",
          sortable: false,
        },
      ],
      displayTickets: [],
      futureTickets: [],
      pastTickets: [],
      selectedTicket: {},
      showPast: false,
      dialog: false,
    };
  },
  async created() {
    const res = await this.$axios.get(
      `/audiences/${this.id}/tickets`,
      this.headers
    );
    const now = new Date();
    this.futureTickets = res.data.filter((ticket) => {
      return now.getTime() <= new Date(ticket.event.open_at).getTime();
    });
    this.pastTickets = res.data.filter((ticket) => {
      return now.getTime() >= new Date(ticket.event.open_at).getTime();
    });
    this.setDisplayTickets();
  },
  computed: {
    ...mapGetters(["headers"]),
    dialogText() {
      const event = this.selectedTicket.event;
      return event ? `${event.name}のチケット取り置きをやめますか？` : "";
    },
  },
  watch: {
    showPast() {
      this.displayTickets = [];
      this.setDisplayTickets();
    },
  },
  methods: {
    setDisplayTickets() {
      if (this.showPast) {
        for (let ticket of this.pastTickets) {
          ticket.event.open_at = this.$dayjs(ticket.event.open_at).format(
            "YYYY MMM DD"
          );
          this.displayTickets.push(ticket);
        }
      } else {
        for (let ticket of this.futureTickets) {
          ticket.event.open_at = this.$dayjs(ticket.event.open_at).format(
            "YYYY MMM DD"
          );
          this.displayTickets.push(ticket);
        }
      }
    },
    async deleteTicket() {
      await this.$axios.delete(
        `/events/${this.selectedTicket.event.id}/tickets/${this.selectedTicket.id}`,
        this.headers
      );
      this.$router.go({ path: this.$router.currentRoute.path, force: true });
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
