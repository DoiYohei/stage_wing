<template>
  <v-col :class="$vuetify.breakpoint.mdAndDown ? 'pa-0' : ''">
    <v-list class="px-3">
      <v-subheader
        v-if="$vuetify.breakpoint.lgAndUp"
        class="grey darken-3 white--text"
      >
        <v-spacer />
        {{ friendship.header }}
        <v-spacer />
      </v-subheader>
      <template v-for="(band, index) in bands">
        <v-list-item :key="band.id">
          <v-spacer v-if="$vuetify.breakpoint.md || $vuetify.breakpoint.sm" />
          <router-link :to="`/bands/${band.id}`" class="d-flex">
            <ListItemAvatar :image="band.image.url" />
            <v-list-item-content>
              <v-list-item-title>
                {{ band.name }}
              </v-list-item-title>
            </v-list-item-content>
          </router-link>
          <v-spacer />
          <v-list-item-icon v-if="isFriend(index)">
            <v-btn @click="startChat(band.id)" icon>
              <v-icon>mdi-email-outline</v-icon>
            </v-btn>
          </v-list-item-icon>
          <v-list-item-action class="ml-4">
            <ButtonFriendship
              :friend-status="friendStatus(index)"
              :band-id="band.id"
              :index="index"
              @change-friendship="changeFriendship"
            />
          </v-list-item-action>
          <v-spacer v-if="$vuetify.breakpoint.md || $vuetify.breakpoint.sm" />
        </v-list-item>
        <v-divider :key="index" v-if="index !== bands.length - 1" />
      </template>
    </v-list>
  </v-col>
</template>

<script>
import ButtonFriendship from "@/components/Buttons/ButtonFriendship";
import ListItemAvatar from "@/components/ListItemAvatar";

export default {
  components: {
    ButtonFriendship,
    ListItemAvatar,
  },
  props: {
    bands: {
      type: Array,
      require: true,
    },
    friendship: {
      type: Object,
      require: true,
    },
  },
  data() {
    return {
      isDefaultStatus: [],
    };
  },
  created() {
    this.setStatus();
  },
  computed: {
    isFriend() {
      return (index) => {
        if (this.friendship.status === "friend") {
          return this.isDefaultStatus[index];
        } else if (this.friendship.status === "invited") {
          return !this.isDefaultStatus[index];
        } else {
          return false;
        }
      };
    },
    friendStatus() {
      return (index) => {
        if (this.isDefaultStatus[index]) {
          return this.friendship.status;
        } else {
          return this.friendship.oppositeStatus;
        }
      };
    },
  },
  watch: {
    bands() {
      this.setStatus();
    },
  },
  methods: {
    setStatus() {
      for (let n = 0; n < this.bands.length; n++) {
        this.isDefaultStatus.push(true);
      }
    },
    changeFriendship(isFollowing, formData, index) {
      this.$emit("change-friendship", isFollowing, formData);
      this.$set(this.isDefaultStatus, index, !this.isDefaultStatus[index]);
    },
    startChat(bandId) {
      this.$emit("start-chat", bandId);
    },
  },
};
</script>
