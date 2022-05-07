<template>
  <v-col sm="10" offset-sm="1" lg="8" offset-lg="2" xl="6" offset-xl="3">
    <v-card outlined>
      <v-img v-if="post.format === 'photo'" :src="post.photo.url" />
      <VuetifyAudio
        v-if="post.format === 'audio'"
        :file="post.audio.url"
        class="black"
      />
      <iframe
        v-if="post.format === 'soundcloud'"
        :src="`https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/${post.media_pass}`"
        width="100%"
        height="166"
        scrolling="no"
        frameborder="no"
      />
      <youtube
        v-if="post.format === 'youtube'"
        :video-id="post.media_pass"
        fitParent
        resize
      />
      <v-card-subtitle class="pt-2 d-flex align-center">
        {{ $dayjs(post.created_at).format("YYYY MMM DD") }}
        <CardAvatar :avatar="post.band" class="ml-2" />
        <v-btn @click="changeLike" icon class="mx-4">
          <v-icon :color="post.favorite ? 'grey lighten-2' : 'grey'" small>
            {{ post.favorite ? "mdi-heart-multiple" : "mdi-heart-outline" }}
          </v-icon>
          {{ post.likes_count }}
        </v-btn>
        <v-menu v-if="isMyPost">
          <template v-slot:activator="{ on, attrs }">
            <v-btn icon v-bind="attrs" v-on="on">
              <v-icon color="grey lighten-1">mdi-dots-horizontal</v-icon>
            </v-btn>
          </template>
          <v-card-text class="pa-0">
            <v-list dense class="py-0" color="grey darken-3">
              <v-list-item-group>
                <v-list-item @click="editable = true">編集する</v-list-item>
                <v-dialog v-model="dialog" width="45vw">
                  <template #activator="{ on, attrs }">
                    <v-list-item v-bind="attrs" v-on="on">削除する</v-list-item>
                  </template>
                  <CardDialog
                    dialogText="この投稿を削除しますか？"
                    @select-excution="deletePost"
                    @close-dialog="closeDialog"
                  />
                </v-dialog>
              </v-list-item-group>
            </v-list>
          </v-card-text>
        </v-menu>
      </v-card-subtitle>
      <v-card-text class="text-left">
        <span
          v-if="post.format === 'news' && !editable"
          class="white--text mr-1"
        >
          News!
        </span>
        <span
          v-if="!editable"
          v-text="post.description"
          class="reflect-return"
        />
        <template v-if="editable">
          <v-textarea
            v-model="post.description"
            @blur="editable = false"
            label="内容"
            auto-grow
            autofocus
            hide-details
            outlined
          />
          <v-card-actions class="d-flex justify-center">
            <v-btn @click="editable = false" outlined>キャンセル</v-btn>
            <v-btn @click="patchPost" outlined>変更する</v-btn>
          </v-card-actions>
        </template>
      </v-card-text>
    </v-card>
  </v-col>
</template>

<script>
import { mapGetters } from "vuex";
import VuetifyAudio from "vuetify-audio";
import CardAvatar from "@/components/Cards/CardAvatar";
import CardDialog from "@/components/Cards/CardDialog";

export default {
  name: "CardPosts",
  components: {
    VuetifyAudio,
    CardAvatar,
    CardDialog,
  },
  props: {
    post: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      dialog: false,
      editable: false,
    };
  },
  computed: {
    ...mapGetters(["isAuthenticatedBand", "userId"]),
    isMyPost() {
      if (this.isAuthenticatedBand) {
        return this.userId === this.post.band.id;
      } else {
        return false;
      }
    },
  },
  methods: {
    deletePost() {
      this.$emit("delete-post", this.post.id);
    },
    patchPost() {
      this.$emit("patch-post", this.post.id, this.post.description);
      this.editable = false;
    },
    changeLike() {
      this.$emit("change-like", this.post);
    },
    closeDialog() {
      this.dialog = false;
    },
  },
};
</script>
