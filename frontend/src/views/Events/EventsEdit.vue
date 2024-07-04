<template>
  <v-container :fluid="$vuetify.breakpoint.lgAndDown">
    <CardPageTitle title="Event 編集" />
    <FormEvent
      v-model="event"
      @submit-forms="patchEvent"
      :is-error="isError"
      submit-text="更新"
    />
  </v-container>
</template>

<script>
import CardPageTitle from "@/components/Cards/CardPageTitle";
import FormEvent from "@/components/Forms/FormEvent";
import { mapGetters } from "vuex";
import { goHome } from "@/utils/routers";

export default {
  components: {
    CardPageTitle,
    FormEvent,
  },
  props: ["id"],
  data() {
    return {
      event: {},
      isError: false,
    };
  },
  async created() {
    try {
      const res = await this.$axios.get(
        `/events/${this.id}/edit`,
        this.headers
      );
      this.event = res.data;
    } catch (error) {
      goHome();
    }
  },
  computed: {
    ...mapGetters(["headers"]),
  },
  methods: {
    async patchEvent(flyer) {
      try {
        const formData = new FormData();
        formData.append("event[name]", this.event.name);
        formData.append("event[place]", this.event.place);
        formData.append("event[ticket_price]", this.event.ticket_price);
        formData.append("event[date]", this.event.date);
        formData.append("event[open_at]", this.event.open_at);
        formData.append("event[start_at]", this.event.start_at);
        formData.append("event[content]", this.event.content);
        formData.append("event[reservation]", this.event.reservation);
        if (flyer) formData.append("event[flyer]", flyer);
        await this.$axios.patch(`/events/${this.id}`, formData, this.headers);
        this.$router.replace(`/events/${this.id}`);
      } catch (error) {
        this.isError = true;
      }
    },
  },
};
</script>
