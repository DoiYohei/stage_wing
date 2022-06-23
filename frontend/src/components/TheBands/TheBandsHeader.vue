<template>
  <v-card color="#121212" flat class="d-flex justify-space-between flex-wrap">
    <v-card color="#121212" flat class="d-flex">
      <v-card-title>{{ band.name }}</v-card-title>
      <template v-if="bandId && !isMyPage">
        <v-card-actions v-if="friendStatus === 'friend'">
          <v-btn @click="startChat" icon>
            <v-icon>mdi-email-outline</v-icon>
          </v-btn>
        </v-card-actions>
        <v-card-actions>
          <v-card-subtitle v-if="friendStatus === 'invited'">
            Friend申請されています
          </v-card-subtitle>
          <ButtonFriendship
            :friend-status="friendStatus"
            :band-id="band.id"
            @change-friendship="changeFriendship"
          />
        </v-card-actions>
      </template>
    </v-card>
    <v-card-actions>
      <v-tabs
        v-if="$vuetify.breakpoint.mdAndUp"
        v-model="tab"
        background-color="#121212"
        grow
      >
        <v-tab v-for="content in contents" :key="content" v-text="content" />
      </v-tabs>
      <v-menu v-if="$vuetify.breakpoint.smAndDown">
        <template #activator="{ on, attrs }">
          <v-btn icon v-bind="attrs" v-on="on">
            <v-app-bar-nav-icon />
          </v-btn>
        </template>
        <v-tabs v-model="tab" vertical>
          <v-tab v-for="content in contents" :key="content" v-text="content" />
        </v-tabs>
      </v-menu>
    </v-card-actions>
  </v-card>
</template>

<script>
import { mapGetters } from "vuex";
import ButtonFriendship from "@/components/Buttons/ButtonFriendship";

export default {
  components: {
    ButtonFriendship,
  },
  props: {
    value: {
      type: Number,
      require: true,
    },
    band: {
      type: Object,
      require: true,
    },
    friendStatus: {
      type: String,
      default: null,
    },
    isMyPage: {
      type: Boolean,
      require: true,
    },
  },
  data() {
    return {
      contents: ["Biography", "Post", "Live"],
    };
  },
  computed: {
    ...mapGetters(["bandId"]),
    tab: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
  },
  methods: {
    startChat() {
      this.$emit("start-chat");
    },
    changeFriendship(isFollowing, formData) {
      this.$emit("change-friendship", isFollowing, formData);
    },
  },
};
</script>
