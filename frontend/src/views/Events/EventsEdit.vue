<template>
  <FormEvent v-model="event" :is-error="isError" @submit-forms="patchEvent">
    <template #page-title>Event 編集</template>
    <template #error-text>
      更新できませんでした。入力事項をご確認の上、もう一度お試しください。
    </template>
    <template #btn-text>更新する</template>
  </FormEvent>
</template>

<script>
import { mapGetters } from "vuex";
import FormEvent from "@/components/Forms/FormEvent";

export default {
  components: {
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
      if (error.response) this.$router.replace("/");
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
        formData.append("event[open_at]", this.event.open_at);
        formData.append("event[start_at]", this.event.start_at);
        formData.append("event[content]", this.event.content);
        formData.append("event[reservation]", this.event.reservation);
        if (flyer) formData.append("event[flyer]", flyer);
        await this.$axios.patch(`/events/${this.id}`, formData, this.headers);
        this.$router.replace(`/events/${this.id}`);
      } catch (error) {
        if (error.response) this.isError = true;
      }
    },
  },
};
</script>
