#!/bin/bash
#
# FinalCalendar Deployment Script
# Ensures fresh Docker builds without cache issues
#

set -e  # Exit on any error

echo "======================================"
echo "FinalCalendar Deployment Script"
echo "======================================"
echo ""

# Check if we're in the right directory
if [ ! -f "fly.toml" ]; then
    echo "ERROR: fly.toml not found. Are you in the FinalCalendar directory?"
    exit 1
fi

# Commit changes first (if there are any)
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "⚠️  Uncommitted changes detected."
    read -p "Do you want to commit these changes? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        read -p "Enter commit message: " commit_msg
        git add -A
        git commit -m "$commit_msg"
        git push origin main
        echo "✅ Changes committed and pushed"
    else
        echo "⚠️  Deploying with uncommitted changes..."
    fi
fi

echo ""
echo "🚀 Starting fresh deployment (no cache)..."
echo ""

# Deploy with no cache and immediate strategy
# --no-cache: Forces Docker to rebuild all layers from scratch
# --strategy immediate: Applies the update immediately without rolling deployment
/root/.fly/bin/flyctl deploy -a hunkofthemonth --no-cache --strategy immediate

echo ""
echo "======================================"
echo "✅ Deployment complete!"
echo "======================================"
echo ""
echo "🔗 Visit: https://hunkofthemonth.shop/project/upload"
echo "📊 Monitor: /root/.fly/bin/flyctl logs -a hunkofthemonth"
echo ""
