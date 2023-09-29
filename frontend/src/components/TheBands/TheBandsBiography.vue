<template>
  <v-card color="#121212" flat class="d-flex flex-wrap">
    <v-col md="7" cols="12" class="pa-0 px-md-2">
      <v-img :src="bandImage" aspect-ratio="1.37" />
    </v-col>
    <v-col md="5" class="text-left pb-0 px-0 px-sm-3">
      <v-card color="#121212" flat>
        <v-card-title class="pb-0 pt-4 pt-md-0">{{ band.name }}</v-card-title>
        <v-card-actions v-if="existsLink" class="pb-0">
          <v-btn
            v-if="isMyPage"
            :to="`/bands/${band.id}/edit`"
            icon
            data-jest="edit-btn"
          >
            <v-icon color="grey lighten-1">mdi-pencil-plus-outline</v-icon>
          </v-btn>
          <ButtonFriendship
            v-if="bandId && !isMyPage"
            :band="band"
            :friend-state="friendState"
            @change-friend-state="changeFriendState"
            data-jest="friendship-btn"
          />
          <v-btn
            v-if="friendState === 'friend'"
            @click="startChat"
            icon
            data-jest="chat-btn"
          >
            <v-icon>mdi-email-outline</v-icon>
          </v-btn>
          <v-btn v-if="band.website" icon :href="band.website">
            <v-icon color="grey lighten-2">mdi-link-variant</v-icon>
          </v-btn>
          <v-btn v-if="band.twitter" icon :href="band.twitter">
            <v-icon color="grey lighten-2">mdi-twitter</v-icon>
          </v-btn>
        </v-card-actions>
        <v-card-text v-if="band.profile" class="pt-4 reflect-return">{{
          band.profile
        }}</v-card-text>
      </v-card>
    </v-col>
  </v-card>
</template>

<script>
import ButtonFriendship from "@/components/Buttons/ButtonFriendship";
import { mapGetters } from "vuex";
import { bandImage } from "@/utils/images";

export default {
  components: {
    ButtonFriendship,
  },
  props: {
    band: {
      type: Object,
      require: true,
    },
    isMyPage: {
      type: Boolean,
      require: true,
    },
    friendState: {
      type: String,
      default: null,
    },
  },
  computed: {
    ...mapGetters(["bandId"]),
    bandImage() {
      return bandImage(this.band.image?.url);
    },
    existsLink() {
      return this.bandId || this.band.website || this.band.twitter;
    },
  },
  methods: {
    startChat() {
      this.$emit("start-chat");
    },
    changeFriendState(isFollowing, formData) {
      this.$emit("change-friend-state", isFollowing, formData);
    },
  },
};
</script>
