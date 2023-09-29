<template>
  <v-col :cols="cols" :offset="offset" class="px-0 px-sm-3">
    <v-card outlined>
      <v-card-subtitle>
        <CardAvatar :avatar="post.band" userType="bands" />
      </v-card-subtitle>
      <v-card-subtitle v-if="post.format !== 'text'" class="pt-0">
        <v-img
          v-if="post.format === 'photo'"
          :src="post.photo.url"
          data-jest="photo"
        />
        <VuetifyAudio
          v-if="post.format === 'audio'"
          :file="post.audio.url"
          data-jest="audio"
          class="black"
        />
        <iframe
          v-if="post.format === 'soundcloud'"
          :src="`https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/${post.media_pass}`"
          width="100%"
          height="166"
          scrolling="no"
          frameborder="no"
          data-jest="soundcloud"
        />
        <youtube
          v-if="post.format === 'youtube'"
          :video-id="post.media_pass"
          fitParent
          resize
          data-jest="youtube"
        />
      </v-card-subtitle>
      <v-card>
        <v-card-subtitle class="py-0 text-body-1 reflect-return">{{
          post.description
        }}</v-card-subtitle>
      </v-card>
      <v-card flat class="d-flex">
        <v-card-subtitle class="py-3 pr-0 text-caption">
          {{ $dayjs(post.created_at).format("-- YYYY MMM DD") }}
        </v-card-subtitle>
        <v-card-actions class="pa-0">
          <v-btn @click="changeLike" icon class="mx-4">
            <v-icon :color="post.favorite ? 'grey lighten-2' : 'grey'" small>
              {{ post.favorite ? "mdi-heart-multiple" : "mdi-heart-outline" }}
            </v-icon>
            {{ post.likes_count }}
          </v-btn>
        </v-card-actions>
        <v-card-actions class="pa-0">
          <v-menu v-if="isMyPost">
            <template v-slot:activator="{ on, attrs }">
              <v-btn icon v-bind="attrs" v-on="on" data-jest="menu-btn">
                <v-icon color="grey lighten-1" small>mdi-dots-vertical</v-icon>
              </v-btn>
            </template>
            <v-card-text class="pa-0" data-jest="owner-menu">
              <v-list dense class="py-0" color="grey darken-3">
                <v-list-item-group>
                  <v-dialog
                    v-model="editDialog"
                    max-width="1000"
                    overlay-color="white"
                    overlay-opacity="0.2"
                    persistent
                  >
                    <template #activator="{ on, attrs }">
                      <v-list-item v-bind="attrs" v-on="on"
                        >編集する
                      </v-list-item>
                    </template>
                    <v-card class="pt-4 pb-3">
                      <ValidationObserver v-slot="{ handleSubmit }">
                        <v-card-text class="pb-0">
                          <InputTextarea
                            v-model="newDescription"
                            label="キャプション"
                            max="500"
                            :isAutofocus="true"
                          />
                        </v-card-text>
                        <v-card-actions class="pt-0">
                          <v-spacer />
                          <v-btn
                            @click="handleSubmit(patchPost)"
                            color="grey darken-3"
                            >変更する
                          </v-btn>
                          <v-btn
                            @click="closeEditDialog()"
                            color="grey darken-3"
                            >キャンセル
                          </v-btn>
                          <v-spacer />
                        </v-card-actions>
                      </ValidationObserver>
                    </v-card>
                  </v-dialog>
                  <v-list-item @click.stop="deleteDialog = true"
                    >削除する
                  </v-list-item>
                  <DialogYesNo
                    v-model="deleteDialog"
                    question="この投稿を削除しますか？"
                    @select-excution="deletePost"
                    @close-dialog="closeDeleteDialog"
                  />
                </v-list-item-group>
              </v-list>
            </v-card-text>
          </v-menu>
        </v-card-actions>
      </v-card>
    </v-card>
  </v-col>
</template>

<script>
import VuetifyAudio from "vuetify-audio";
import CardAvatar from "@/components/Cards/CardAvatar";
import DialogYesNo from "@/components/Dialogs/DialogYesNo";
import InputTextarea from "@/components/Inputs/InputTextarea";
import { ValidationObserver } from "vee-validate";
import { mapGetters } from "vuex";
import { respondCols } from "@/utils/grids";

export default {
  components: {
    VuetifyAudio,
    CardAvatar,
    DialogYesNo,
    InputTextarea,
    ValidationObserver,
  },
  props: {
    post: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      newDescription: "",
      deleteDialog: false,
      editDialog: false,
    };
  },
  computed: {
    ...mapGetters(["bandId"]),
    isMyPost() {
      return this.bandId === this.post.band.id;
    },
    cols() {
      return respondCols(this.$vuetify.breakpoint, 6, 8, 10, 12, 12);
    },
    offset() {
      return respondCols(this.$vuetify.breakpoint, 3, 2, 1, 0, 0);
    },
  },
  watch: {
    editDialog(value) {
      this.newDescription = value ? this.post.description : "";
    },
  },
  methods: {
    deletePost() {
      this.$emit("delete-post", this.post.id);
      this.closeDeleteDialog();
    },
    closeDeleteDialog() {
      this.deleteDialog = false;
    },
    patchPost() {
      this.$emit("patch-post", this.post.id, this.newDescription);
      this.closeEditDialog();
    },
    closeEditDialog() {
      this.editDialog = false;
    },
    changeLike() {
      this.$emit("change-like", this.post);
    },
  },
};
</script>
