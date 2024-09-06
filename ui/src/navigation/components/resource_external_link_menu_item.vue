<template>
  <MenuItem
    :name="resource.slug"
    @click="visitExternalLink"
  >
    <div class="ivu-menu-item-text">
      <CustomIcon
        :type="resource.icon"
        :size="iconSize"
      />
      {{ resource.name.replace('/', '\u200B/') }}
    </div>
  </MenuItem>
</template>

<script>
import CustomIcon from 'utils/components/custom_icon'

export default {
  name: 'ResourceExternalLinkMenuItem',
  components: {
    CustomIcon
  },
  props: {
    resource: {
      type: Object,
      required: true
    },
    size: {
      type: String,
      required: false,
      default: 'default'
    },
  },
  computed: {
    iconSize () {
      if (this.size === 'small') {
        return 14
      } else {
        return 16
      }
    },
  },
  methods: {
    visitExternalLink () {

      // if the link is relative, use the current url as the base and navigate to the relative path
      // otherwise, navigate to the absolute path

      if(this.resource.relative) {
        const baseUrl = `${window.location.protocol}//${window.location.host}`;

        let path = this.resource.url;
        if(!path.startsWith('/')) {
          path = `/${path}`;
        }

        window.location.href = `${baseUrl}${path}`;
      } else {
        window.location.href = this.resource.url;
      }
    }
  }
}
</script>

<style lang="scss">
@import 'utils/styles/variables';

@media screen and (min-width: $breakpoint-sm) {
  .ivu-menu-item-text {
    width: 164px
  }
}
</style>
